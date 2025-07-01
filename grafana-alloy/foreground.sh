echo "Still setting up, please wait"

dots=""
while ! tail -n1 ~/.bashrc 2>/dev/null | grep -q "setup-complete"; do
  dots+="."
  echo -n "${dots}"
  sleep 1
done

echo " ✅ ready!"

# Run silently, only show final output
(
  # Define colors
  RESET=$'\033[0m'
  C208=$'\033[38;5;208m'
  C214=$'\033[38;5;214m'
  C220=$'\033[38;5;220m'
  C226=$'\033[38;5;226m'
  YELLOW=$'\033[1;33m'
  GREEN=$'\033[38;5;82m'

  GRAFANA_LOGO=$(cat <<'EOF'
                        ltmg
                       tmmmmtl
                     lmmmmmmmmg
                 lggtmmmmmmmmmmmmttggtmmmm
     gttmmmmmmttmmmmmmmmmmmmmmmmmmmmmmmmmml
     tmmmmmmmmmmmmmmmm               tmmmmtl
     lmmmmmmmmmmmmt                      mmmg
      gmmmmmmmmmt                          tmt
       lmmmmmmmg           llgggggll         mm
       tmmmmmmg         gtmmmmmmmmmmmmtl      mg
       mmmmmmm        gmmmg        tmmmmmg     m
     ltLLLLLLg       gLLt            gLLLLml
  ltmLLLLLLLLg       LLL              lLLLLm
 tLLLLLLLLLLLm       mLL               mLLLLg
tLLLLLLLLLLLLLl       tLt              LLLLLt
  lLLLLLLLLLLLLg        lLtglllg      gLLLLLLg
       gLLLLLLLLtl                   gLLLLLLLLm
          tLLLLLLLmg               gmLLLLLLLLm
            mGGGGGGGLmtglll  llggmLGGGGGGl
            LGGGGGGGGGGGGGGGGGGGGGGGGGG
           lGGGGGGGGGGGGGGGGGGGGGGGGGg
            GGGGGGL         gGGGGGGGL
                               LGGGt
                                  g
EOF
  )

  GRAFANA_NAME=$(cat <<'EOF'
  _____            __                    _           _         
 / ____|          / _|                  | |         | |        
| |  __ _ __ __ _| |_ __ _ _ __   __ _  | |     __ _| |__  ___ 
| | |_ | '__/ _` |  _/ _` | '_ \ / _` | | |    / _` | '_ \/ __|
| |__| | | | (_| | || (_| | | | | (_| | | |___| (_| | |_) \__ \
 \_____|_|  \__,_|_| \__,_|_| |_|\__,_| |______\__,_|_.__/|___/
EOF
  )

  # Print each line of the logo with a gradient
  i=0
  while IFS= read -r line; do
    case $i in
      [0-4]) COLOR=$C208 ;;
      [5-10]) COLOR=$C214 ;;
      [11-17]) COLOR=$C220 ;;
      *) COLOR=$C226 ;;
    esac
    echo -e "${COLOR}${line}${RESET}"
    ((i++))
  done <<< "$GRAFANA_LOGO"

  echo -e "${YELLOW}${GRAFANA_NAME}${RESET}"
  echo -e ""
  echo -e "${GREEN}Welcome to your Grafana training environment.${RESET}"
) >/dev/tty

source .bashrc