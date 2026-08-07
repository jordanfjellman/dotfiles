function submit_mobile --description 'Submit the discipleship mobile app to both stores'
    gh workflow run mobile.submit-to-testflight.yml --repo lifewayit/lifeway-discipleship
    and gh workflow run mobile.submit-to-play-store.yml --repo lifewayit/lifeway-discipleship
end
