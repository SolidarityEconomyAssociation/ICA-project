
: ${1?"Usage: $0 NO VERSION ARGUMENT"}
ver=$1
if echo "$1" | grep "[0-9]\+\.[0-9]\+\.[0-9]\+"
then
        echo creating and uploading sea-map with version $1
        sed -i "s/semver:\^[[:digit:]]\+\.[[:digit:]]\+\.[[:digit:]]\+\"/semver:\^$1\"/" package.json
else
	echo No Valid Version, Cannot Deploy, supply versio as the first argument in the form of numbers.numbers.numbers e.g 0.1.38
        exit 0
fi

rm -r node_modules/
npm update
npm install
npm run build

seaserv="dev-0"
if [ "$2" == "dev" ]; then
        ./deploy_targets/$2
elif [ "$2" == "prod" ]; then
        ./deploy_targets/$2
        sea-serv="sea-0"
else
        echo No server target can be dev/prod, deploying to dev
        ./deploy_targets/dev
fi

temp=`cat config/version.json`
echo "${temp::-1}, \"version\":\"${ver}\"}" > config/version.json

#deploy to git
git add -u
git commit -m "bumped version"
git push

#refresh cache?

npm run deploy
#npm config set playground:deploy_to dev-0:/var/www/vhosts/playground.solidarityeconomy.coop/www/
