#!/bin/bash

version=9.0.2
image_name=codecutteruk/seafile
set -e -x
./ci/install_deps.sh

(
    cd image
    make base server
    # make pro-base
    # make pro-server
)

mkdir -p /opt/seafile-data
docker run -d --name seafile -e SEAFILE_SERVER_HOSTNAME=127.0.0.1 -v /opt/seafile-data:/shared -p 80:80 -p 443:443 $image_name:$version-$TAG_ARCH

cat > doc.md <<EOF
# Doc

Hello world.
EOF

sleep 50
python ci/upload.py doc.md
python ci/validate_file.py doc.md
docker restart seafile
sleep 30
python ci/validate_file.py doc.md
docker rm -f seafile
docker run -d --name seafile -e SEAFILE_SERVER_HOSTNAME=127.0.0.1 -v /opt/seafile-data:/shared -p 80:80 -p 443:443 $image_name:$version-$TAG_ARCH
sleep 30
python ci/validate_file.py doc.md

rm -rf doc.md

# if [[ $TRAVIS_TAG =~ ^v([0-9]*?)(\.([0-9])*?){2}-pro$ ]]; then
#     ci/publish-pro-image.sh
# elif [[ $TRAVIS_TAG =~ ^v([0-9]*?)(\.([0-9])*?){2}$ ]]; then
#     ci/publish-image.sh
# elif [[ $TRAVIS_TAG =~ ^seafile-pro-base$ ]]; then
#     ci/publish-pro-base.sh
# elif [[ $TRAVIS_TAG =~ ^seafile-base$ ]]; then
#     ci/publish-base.sh
# else
#     echo "Not going to push the image to docker hub, since it's not a build triggered by a tag"
# fi
