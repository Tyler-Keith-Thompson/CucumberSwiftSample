# get the latest code
if [[ -n ${TRAVIS_BRANCH} ]]; then
    git config --global user.email "travis@travis-ci.org"
    git config --global user.name "Travis CI"
    git config --global push.default current
fi
git checkout master
git reset --hard origin/master
git clean -df

# do the podspec stuff
npm install -g podspec-bump #uncomment if you need the node package
npm install simple-plist
podspec-bump -w

# commit the podspec bump
node edit-plist.js `podspec-bump --dump-version`
git commit -am "[ci skip] publishing pod version: `podspec-bump --dump-version`" 
git tag "`podspec-bump --dump-version`"
git push https://${PERSONAL_ACCESS_TOKEN}@github.com/Tyler-Keith-Thompson/CucumberSwift.git HEAD -u $(podspec-bump --dump-version)
git reset --hard
git clean -df
curl --data "{\"tag_name\": \"`podspec-bump --dump-version`\",\"target_commitish\": \"master\",\"name\": \"`podspec-bump --dump-version`\",\"body\": \"Release of version `podspec-bump --dump-version`\",\"draft\": false,\"prerelease\": false}" -H "Authorization: token $PERSONAL_ACCESS_TOKEN" "https://api.github.com/repos/Tyler-Keith-Thompson/CucumberSwift/releases"
pod repo add-cdn trunk 'https://cdn.cocoapods.org/'
pod trunk push CucumberSwift.podspec --allow-warnings