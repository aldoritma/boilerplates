#!/bin/sh

#


BUILDDIR="build"
DISTDIR="dist"

Install_bootsrap()
{
  bower install bootstrap-sass --save
  rsync -az $BUILDDIR/vendor/bootstrap-sass/assets/stylesheets/  $BUILDDIR/bootstrap/
  touch $BUILDDIR/scss/vendor.scss
  echo "@import "../bootstrap/bootstrap"; " > $BUILDDIR/scss/vendor.scss
  rsync -az $BUILDDIR/vendor/bootstrap-sass/assets/javascripts/bootstrap.js $BUILDDIR/scripts/modules/bootstrap.js
  rsync -az $BUILDDIR/vendor/bootstrap-sass/assets/fonts/ dist/assets/fonts/

}

Install_foundation()
{
  bower install foundation-sass --save
  rsync -az $BUILDDIR/vendor/foundation-sites/scss $BUILDDIR/foundation/
  touch $BUILDDIR/scss/vendor.scss
  rsync -az $BUILDDIR/vendor/foundation-sites/dist/foundation.js $BUILDDIR/scripts/modules/foundation.js
  echo "@import "../bootstrap/bootstrap"; " > $BUILDDIR/scss/vendor.scss
  echo "@include foundation-everything;"  > $BUILDDIR/scss/vendor.scss
}

Install_susy()
{
  bower install susy --save
  echo "@import "../vendor/susy/sass/susy"; " > $BUILDDIR/scss/application.scss
}

Create_boilerplates()
{
  mkdir $projectname
  touch .gitignore
  echo ".DS_STORE" > .gitignore
  echo ".codekit-cache/" > .gitignore
  echo $'*.zip\n*.rar\n*.tar.gz\n*.sass-cache' > .gitignore
  cat <<- _EOF_ ->> .bowerrc
  {
    "directory" : "build/vendor"
  }
  _EOF_


  if [ "$1" == "sass" ] || [ "$1" == "less" ]  ; then
    mkdir $BUILDDIR $DISTDIR
    mkdir $BUILDDIR/scss/{generic,components,extensions,objects,tools} $BUILDDIR/scripts/{plugins,modules,libraries}  $BUILDDIR/views/{organisms,pages,layouts,partials}
    mkdir $DISTDIR/assets/{css,scripts,images,fonts}

    # installing frameworks
    case $1 in
      "bootstrap")
        Install_bootsrap
        ;;
      "foundation")
        Install_foundation
        ;;
      "susy")
        Install_susy
        ;;
      *)
        break
        ;;
    esac

    touch $BUILDDIR/scss/application.scss
    touch $BUILDDIR/scss/_variables.scss
    touch $BUILDDIR/scss/**/.gitkeep

    else

      mkdir assets/{css,scripts,images,fonts}
  fi
}




if ! type "git" &> /dev/null;then
  echo "You Must Install Git First"
  exit;
fi

echo "Welcome to quixote!!"
read -p "Your Projectname: " projectname

echo "What CSS Pre-Pros do you want to use: "
PS3="Answer: "
cssprepros=("sass" "less" "vanilla")
select opt in "${cssprepros[@]}"
do
    case $opt in
        "sass")
            PREPROS=$opt
            break
            ;;
        "less")
            PREPROS=$opt
            break
            ;;
        "vanilla")
            PREPROS=$opt
            break
            ;;
        *)
          echo "Please choose the options"
        ;;
    esac
done


echo "What Frameworks do you want to use: "
PS3="Answer: "
framework=("bootstrap" "foundation" "none")

if []
select opt in "${framework[@]}"
do
    case $opt in
        "bootstrap")
            FRAMEWORKS=$opt
            break
            ;;
        "foundation")
            FRAMEWORKS=$opt
            break
            ;;
        "susy")
            FRAMEWORKS=$opt
            break
            ;;
        "none")
            FRAMEWORKS=$opt
            break
            ;;
        *)
          echo "Please choose the options"
        ;;
    esac
done
#
# Create_directory $PREPROS