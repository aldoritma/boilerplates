#!/bin/sh

#



BUILDDIR="build"
DISTDIR="dist"

Initial_commit()
{
  git init
  git add .
  git commit -m "initial commit"
}

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

bowerrc()
{
cat <<EOF >> .bowerrc
{
  "directory" : "build/vendor"
}
EOF
}




Create_boilerplates()
{
  mkdir $1
  cd $1
  touch .gitignore
  echo ".DS_STORE" > .gitignore
  echo ".codekit-cache/" > .gitignore
  echo $'*.zip\n*.rar\n*.tar.gz\n*.sass-cache' > .gitignore
  bowerrc


  if [ "$2" == "sass" ] ; then
    mkdir $BUILDDIR $DISTDIR
    mkdir -p  $BUILDDIR/scss/{generic,components,extensions,objects,tools} $BUILDDIR/scripts/{plugins,modules,libraries}  $BUILDDIR/views/{organisms,pages,layouts,partials}
    mkdir -p $DISTDIR/assets/{css,scripts,images,fonts}

    # installing frameworks
    case $3 in
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
    find  $BUILDDIR/{scss,scripts,views} -type d -exec touch  {}/.gitkeep \;
    find  $DISTDIR/assets/ -type d -exec touch  {}/.gitkeep \;

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
cssprepros=("sass" "vanilla")
select opt in "${cssprepros[@]}"
do
    case $opt in
        "sass")
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


if [ "$PREPROS" == "sass" ]; then
  echo "What Frameworks do you want to use: "
  PS3="Answer: "
  framework=("bootstrap" "foundation" "susy" "none")
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
fi



Create_boilerplates $projectname $PREPROS $FRAMEWORKS
Initial_commit
