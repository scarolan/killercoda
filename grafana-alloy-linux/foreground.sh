(
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

YELLOW=$'\033[38;5;208m'
RESET=$'\033[0m'

clear
echo -e "${YELLOW}${GRAFANA_LOGO}${RESET}"
echo "Welcome to your Grafana training environment. Please hit enter to start the lab."
)
sleep 1
exit 0