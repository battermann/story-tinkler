# Story Tinkler

## Run with docker

Clone repository:

    git clone git@github.com:battermann/story-tinkler.git

Build docker image:

    docker build . -t story-tinkler

Edit the file `public/story.txt` and create your own story using Markdown and a simple special syntax to connect story parts together.

Run container:

    docker run -d -p 5000:5000 -e PORT=5000 story-tinkler

Now open [http://localhost:5000](http://localhost:5000) in your browser. The app will take a few seconds to build, then you should see a page containing your story.

This project is bootstrapped with [Create Elm App](https://github.com/halfzebra/create-elm-app).
