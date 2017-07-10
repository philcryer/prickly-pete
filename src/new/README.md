https://github.com/dtag-dev-sec/tpotce


A    cp /root/tpot/data/imgcfg/hp_images.conf /root/tpot/data/images.conf
  ;;
  INDUSTRIAL)
    echo "### Preparing INDUSTRIAL flavor installation."
    cp /root/tpot/data/imgcfg/industrial_images.conf /root/tpot/data/images.conf
  ;;
  TPOT)
    echo "### Preparing TPOT flavor installation."
    cp /root/tpot/data/imgcfg/tpot_images.conf /root/tpot/data/images.conf
  ;;
  ALL)
    echo "### Preparing EVERYTHING flavor installation."
    cp /root/tpot/data/imgcfg/all_images.conf /root/tpot/data/images.conf
  ;;
esac

# Let's load docker images
fuECHO "### Loading docker images. Please be patient, this may take a while."
for name in $(cat /root/tpot/data/images.conf)
  do
    docker pull dtagdevsec/$name:latest1610
B
B
B
B
B
B
  done
A
A
A
A
A





https://github.com/DinoTools/dionaea-docker
