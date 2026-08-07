function submit_tv --description 'Submit the discipleship TV app to all three stores'
    gh workflow run tv.submit-to-testflight.yml --repo lifewayit/lifeway-discipleship
    and gh workflow run tv.submit-to-play-store.yml --repo lifewayit/lifeway-discipleship
    and gh workflow run tv.submit-to-amazon-appstore.yml --repo lifewayit/lifeway-discipleship
end
