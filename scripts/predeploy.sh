# predeploy cleanup for debian repo
cd linux/debian
make predeploy
cd ../..

# predeploy cleanup for arch repo
cd linux/arch
make predeploy
cd ../..

# clean up files that are not needed for deployment
rm -f .gitignore
rm -f docker-compose.yml
rm -f Dockerfile.*
rm -f entrypoint.*.sh
rm -f vercel.json
rm -f .editorconfig
rm -f Makefile

# clean up folders that are not needed for deployment
rm -rf scripts
rm -rf .github
rm -rf .devcontainer
rm -rf .git
