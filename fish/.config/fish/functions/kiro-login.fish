function kiro-login --description 'Log kiro-cli in through Lifeway SSO'
    kiro-cli login --use-device-flow --license=pro --identity-provider=https://lifeway.awsapps.com/start --region=us-east-1
end
