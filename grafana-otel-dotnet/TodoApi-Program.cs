using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using Grafana.OpenTelemetry;
using OpenTelemetry.Trace;
using OpenTelemetry.Metrics;
using OpenTelemetry.Logs;
using System.Diagnostics;

// Create a custom activity source for manual instrumentation examples
public static class MyAppTracing
{
    public static readonly ActivitySource ActivitySource = new ActivitySource("TodoApi.Activities");
}

var builder = WebApplication.CreateBuilder(args);

// Add OpenTelemetry logging
builder.Logging.AddOpenTelemetry(logging => logging
    .UseGrafana()
    .AddConsoleExporter());

// Configure OpenTelemetry tracing and metrics
builder.Services.AddOpenTelemetry()
    .WithTracing(tracing => tracing
        .UseGrafana()
        .AddConsoleExporter()
        .AddSource("TodoApi.Activities"))
    .WithMetrics(metrics => metrics
        .UseGrafana()
        .AddConsoleExporter());

// Add services to the container.
builder.Services.AddEndpointsApiExplorer();
builder.Services.AddSwaggerGen();
builder.Services.AddDbContext<TodoDb>(opt => opt.UseInMemoryDatabase("TodoList"));

var app = builder.Build();

// Configure the HTTP request pipeline.
app.UseSwagger();
app.UseSwaggerUI();

app.MapGet("/", () => Results.Redirect("/swagger"));

// Define API endpoints
app.MapGet("/todoitems", async (TodoDb db, ILogger<Program> logger) =>
{
    logger.LogInformation("Getting all todo items");
    return await db.Todos.ToListAsync();
});

app.MapGet("/todoitems/{id}", async (int id, TodoDb db, ILogger<Program> logger) =>
{
    var result = await db.Todos.FindAsync(id);
    if (result == null)
    {
        logger.LogWarning("Todo item with ID {Id} not found", id);
        return Results.NotFound();
    }
    
    logger.LogInformation("Retrieved todo item with ID {Id}", id);
    return Results.Ok(result);
});

app.MapPost("/todoitems", async (Todo todo, TodoDb db, ILogger<Program> logger) =>
{
    // Example of manual instrumentation
    using var activity = MyAppTracing.ActivitySource.StartActivity("CreateTodoItem");
    activity?.SetTag("todo.name", todo.Name);
    
    db.Todos.Add(todo);
    await db.SaveChangesAsync();
    
    logger.LogInformation("Created new todo item with ID {Id}", todo.Id);
    
    return Results.Created($"/todoitems/{todo.Id}", todo);
});

app.MapPut("/todoitems/{id}", async (int id, Todo inputTodo, TodoDb db, ILogger<Program> logger) =>
{
    var todo = await db.Todos.FindAsync(id);

    if (todo is null) 
    {
        logger.LogWarning("Cannot update - todo item with ID {Id} not found", id);
        return Results.NotFound();
    }

    todo.Name = inputTodo.Name;
    todo.IsComplete = inputTodo.IsComplete;

    await db.SaveChangesAsync();
    logger.LogInformation("Updated todo item with ID {Id}", id);

    return Results.NoContent();
});

app.MapDelete("/todoitems/{id}", async (int id, TodoDb db, ILogger<Program> logger) =>
{
    if (await db.Todos.FindAsync(id) is Todo todo)
    {
        db.Todos.Remove(todo);
        await db.SaveChangesAsync();
        logger.LogInformation("Deleted todo item with ID {Id}", id);
        return Results.Ok(todo);
    }

    logger.LogWarning("Cannot delete - todo item with ID {Id} not found", id);
    return Results.NotFound();
});

// Add an endpoint that generates errors for testing
app.MapGet("/error", () => 
{
    throw new InvalidOperationException("This is a test exception");
});

// Add a load generator endpoint to help create interesting telemetry
app.MapGet("/generate-load", async (HttpContext context, TodoDb db, ILogger<Program> logger) => 
{
    logger.LogInformation("Generating sample load");
    
    // Create some todos
    for (int i = 0; i < 5; i++)
    {
        var todo = new Todo { Name = $"Generated Task {DateTime.Now.Ticks}", IsComplete = false };
        db.Todos.Add(todo);
    }
    await db.SaveChangesAsync();
    
    // Read all todos
    var todos = await db.Todos.ToListAsync();
    
    // Update some todos
    foreach (var todo in todos.Take(3))
    {
        todo.IsComplete = true;
        todo.Name += " (completed)";
    }
    await db.SaveChangesAsync();
    
    // Delete one todo if we have more than 20
    if (todos.Count > 20)
    {
        db.Todos.Remove(todos.Last());
        await db.SaveChangesAsync();
    }
    
    // Occasionally generate an error
    if (Random.Shared.Next(10) == 0)
    {
        try
        {
            throw new ApplicationException("Random error during load generation");
        }
        catch (Exception ex)
        {
            logger.LogError(ex, "Error occurred during load generation");
        }
    }
    
    return Results.Ok(new { message = "Load generated successfully", count = todos.Count });
});

app.Run();

class Todo
{
    public int Id { get; set; }
    public string? Name { get; set; }
    public bool IsComplete { get; set; }
}

class TodoDb : DbContext
{
    public TodoDb(DbContextOptions<TodoDb> options)
        : base(options) { }

    public DbSet<Todo> Todos => Set<Todo>();
}
