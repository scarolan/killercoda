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
  ORANGE=$'\033[38;5;208m'
  YELLOW=$'\033[1;33m'
  GREEN=$'\033[38;5;82m'
  RESET=$'\033[0m'

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

  # Put any startup commands you need here
  systemctl start grafana-server
  systemctl start alloy
  # Next we clear the screen and print the welcome message
  clear
  echo -e "${ORANGE}${GRAFANA_LOGO}${RESET}"
  echo -e "${YELLOW}${GRAFANA_NAME}${RESET}"
  echo -e ""
  echo -e "${GREEN}Welcome to your Grafana training environment. Please hit enter to start the lab.${RESET}"
) >/dev/tty
touch .theia/settings.json
# exit 0