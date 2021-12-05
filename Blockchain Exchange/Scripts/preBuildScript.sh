if which swiftlint >/dev/null; then 
    swiftlint autocorrect
    swiftlint
else 
    echo "Warning: please install Brewfile dependencies."
fi