fw_tag=$(git describe --always --dirty --match "firmware-*")

# Convert to lower cases
fw_tag=${fw_tag,,}

# Setup common variable
fw_release_folder=./bin/targets/ar71xx/fw_release
tx99_fw="doodle-labs-${fw_tag}-ar71xx-generic-smartradio_tx99-squashfs-sysupgrade.bin"
tx99_rwart_fw="doodle-labs-${fw_tag}-ar71xx-generic-smartradio_tx99_rwart-squashfs-sysupgrade.bin"
rwart_fw="doodle-labs-${fw_tag}-ar71xx-generic-smartradio_rwart-squashfs-sysupgrade.bin"
release_fw="doodle-labs-${fw_tag}-ar71xx-generic-smartradio-squashfs-sysupgrade.bin"
image_builder="doodle-labs-imagebuilder-${fw_tag}-ar71xx-generic.Linux-x86_64.tar.xz"
sdk_builder="doodle-labs-sdk-${fw_tag}-ar71xx-generic_gcc-7.5.0_musl.Linux-x86_64.tar.xz"

rm -rf $fw_release_folder
mkdir -p $fw_release_folder

./config.sh -t; date; make -j16; date;
# Copy TX99 FW
echo "Copy ./bin/targets/ar71xx/generic/$tx99_rwart_fw to $fw_release_folder folder"
cp -rf ./bin/targets/ar71xx/generic/$tx99_rwart_fw $fw_release_folder
echo "Copy ./bin/targets/ar71xx/generic/$tx99_fw to $fw_release_folder folder"
cp -rf ./bin/targets/ar71xx/generic/$tx99_fw $fw_release_folder
./config.sh -r; date; make -j16; date; 

# Copy RO Release FW
echo "Copy ./bin/targets/ar71xx/generic/$release_fw to $fw_release_folder folder"
cp -rf ./bin/targets/ar71xx/generic/$release_fw $fw_release_folder
echo "Copy ./bin/targets/ar71xx/generic/$image_builder to $fw_release_folder folder"
cp -rf ./bin/targets/ar71xx/generic/$image_builder $fw_release_folder
echo "Copy ./bin/targets/ar71xx/generic/$sdk_builder to $fw_release_folder folder"
cp -rf ./bin/targets/ar71xx/generic/$sdk_builder $fw_release_folder

# Create the SHA-256 hash for RO release FW
sha256sum ./bin/targets/ar71xx/generic/$release_fw > $fw_release_folder/sha256-$fw_tag.txt

./config.sh ; date; make -j16; date;
# Copy RWART FW
echo "Copy ./bin/targets/ar71xx/generic/$rwart_fw to $fw_release_folder folder"
cp -rf ./bin/targets/ar71xx/generic/$rwart_fw $fw_release_folder

