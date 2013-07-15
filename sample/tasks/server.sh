#filePath="$PWD/$0"
#[ -f "$filePath" ] || echo "load err, please use it in project root"
cp coffee/index.html js/
cp -r coffee/assets js/
cp -r coffee/app/templates js/app/
coffee -o js/ -c coffee/
coffee app.coffee
