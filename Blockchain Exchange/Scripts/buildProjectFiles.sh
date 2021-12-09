if which xcodegen >/dev/null; then 
    xcodegen --spec ../ExchangeLocalDataSource/project.yml
    xcodegen --spec ../ExchangeRemoteDataSource/project.yml
    xcodegen --spec ../ExchangeServices/project.yml
    xcodegen --spec ../ExchangeApp/project.yml

else 
    echo "Warning: please install Brewfile dependencies."
fi