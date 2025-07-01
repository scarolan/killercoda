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
  # Startup sequence
  systemctl start grafana-server
  systemctl start alloy
  clear

  echo -e "\033[38;2;255;102;0m                        ltmg\033[0m"
  echo -e "\033[38;2;255;102;0m                       tmmmmtl\033[0m"
  echo -e "\033[38;2;255;102;0m                     lmmmmmmmmg\033[0m"
  echo -e "\033[38;2;255;122;0m                 lggtmmmmmmmmmmmmttggtmmmm\033[0m"
  echo -e "\033[38;2;255;122;0m     gttmmmmmmttmmmmmmmmmmmmmmmmmmmmmmmmmml\033[0m"
  echo -e "\033[38;2;255;122;0m     tmmmmmmmmmmmmmmmm               tmmmmtl\033[0m"
  echo -e "\033[38;2;255;142;0m     lmmmmmmmmmmmmt                      mmmg\033[0m"
  echo -e "\033[38;2;255;142;0m      gmmmmmmmmmt                          tmt\033[0m"
  echo -e "\033[38;2;255;142;0m       lmmmmmmmg           llgggggll         mm\033[0m"
  echo -e "\033[38;2;255;162;0m       tmmmmmmg         gtmmmmmmmmmmmmtl      mg\033[0m"
  echo -e "\033[38;2;255;162;0m       mmmmmmm        gmmmg        tmmmmmg     m\033[0m"
  echo -e "\033[38;2;255;162;0m     ltLLLLLLg       gLLt            gLLLLml\033[0m"
  echo -e "\033[38;2;255;182;0m  ltmLLLLLLLLg       LLL              lLLLLm\033[0m"
  echo -e "\033[38;2;255;182;0m tLLLLLLLLLLLm       mLL               mLLLLg\033[0m"
  echo -e "\033[38;2;255;182;0mtLLLLLLLLLLLLLl       tLt              LLLLLt\033[0m"
  echo -e "\033[38;2;255;202;0m  lLLLLLLLLLLLLg        lLtglllg      gLLLLLLg\033[0m"
  echo -e "\033[38;2;255;202;0m       gLLLLLLLLtl                   gLLLLLLLLm\033[0m"
  echo -e "\033[38;2;255;202;0m          tLLLLLLLmg               gmLLLLLLLLm\033[0m"
  echo -e "\033[38;2;255;222;0m            mGGGGGGGLmtglll  llggmLGGGGGGl\033[0m"
  echo -e "\033[38;2;255;222;0m            LGGGGGGGGGGGGGGGGGGGGGGGGGG\033[0m"
  echo -e "\033[38;2;255;222;0m           lGGGGGGGGGGGGGGGGGGGGGGGGGg\033[0m"
  echo -e "\033[38;2;255;242;0m            GGGGGGL         gGGGGGGGL\033[0m"
  echo -e "\033[38;2;255;242;0m                               LGGGt\033[0m"
  echo -e "\033[38;2;255;242;0m                                  g\033[0m"

  GRAFANA_NAME=$(cat <<'EOF'
  _____            __                    _           _         
 / ____|          / _|                  | |         | |        
| |  __ _ __ __ _| |_ __ _ _ __   __ _  | |     __ _| |__  ___ 
| | |_ | '__/ _\` |  _/ _\` | '_ \ / _\` | | |    / _\` | '_ \/ __|
| |__| | | | (_| | || (_| | | | | (_| | | |___| (_| | |_) \__ \
 \_____|_|  \__,_|_| \__,_|_| |_|\__,_| |______\__,_|_.__/|___/
EOF
  )

  echo -e "\033[1;33m${GRAFANA_NAME}\033[0m"
  echo -e ""
  echo -e "\033[38;5;82mWelcome to your Grafana training environment.\033[0m"
) >/dev/tty

source .bashrc
