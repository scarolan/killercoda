(
GRAFANA_NAME=$(cat <<'EOF'
  _____            __                    _           _         
 / ____|          / _|                  | |         | |        
| |  __ _ __ __ _| |_ __ _ _ __   __ _  | |     __ _| |__  ___ 
| | |_ | '__/ _` |  _/ _` | '_ \ / _` | | |    / _` | '_ \/ __|
| |__| | | | (_| | || (_| | | | | (_| | | |___| (_| | |_) \__ \
 \_____|_|  \__,_|_| \__,_|_| |_|\__,_| |______\__,_|_.__/|___/
EOF

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

YELLOW=$'\033[38;5;208m'
ORANGE=$'\033[38;5;208m'
GREEN=$'\033[38;5;82m'
RESET=$'\033[0m'
)

clear
echo -e "${YELLOW}${GRAFANA_LOGO}${RESET}"
echo -e "${YELLOW}${GRAFANA_NAME}${RESET}"
echo -e "${GREEN}Welcome to your Grafana training environment. Please hit enter to start the lab.${RESET}"
sleep 1
exit 0