if which xcodegen >/dev/null; then 
    xcodegen --spec ../ExchangeAPI/project.yml
    xcodegen --spec ../ExchangeServices/project.yml
    xcodegen --spec ../ExchangeApp/project.yml
else 
    echo "Warning: please install Brewfile dependencies."
fi