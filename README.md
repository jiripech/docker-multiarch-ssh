# Docker Multiarch SSH

## WHY?
As I used Github Actions on the Github public runners, I quickly found out that debugging the deployment actions might be a huge pain (you know where) and will be probably better to do that via directly accessing to the runner itself.
And that led me to the idea of bringing up two [Github Private Runners](https://docs.github.com/en/actions/how-tos/manage-runners/self-hosted-runners/add-runners):
  - MacBook (M1 Max, 32 GB RAM), which is not always up
  - Synology NAS (Intel Atom, 8 GB RAM), which almost never sleeps, but it's very slow compared to the workstation

So this project was basically my quick start for testing a multiarchitecture docker build of a clean linux with remote shell access and when I knew it's working,
I moved to creating a [Github private runner in Docker](https://github.com/jiripech/docker-github-runner) project, where I moved to glibc based distribution, because almost nothing works on Alpine (though MUSL) from scratch.

## HOW?
Created a basic build script and had some fun with ChatGPT (free tier) to do the rest.

## TODO
Feel free to open an issue or a PR if you find something that can be improved.
You can also use the [Discussions](https://github.com/jiripech/docker-multiarch-ssh/discussions) to ask questions or share your experience and ideas.
Don't forget to star the project if you find it useful.


