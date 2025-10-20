# Node.js - Sample Web Application

This is a sample Node.js web app using the Express framework and EJS templates.

The app has been designed with cloud native demos & containers in mind, in order to provide a real working application for deployment, something more than "hello-world" but with the minimum of pre-reqs. It is not intended as a complete example of a fully functioning architecture or complex software design.

Typical uses would be deployment to Kubernetes, demos of Docker, CI/CD (build pipelines are provided), deployment to cloud (Azure) monitoring, auto-scaling

The app has several basic pages accessed from the top navigation menu, some of which are only lit up when certain configuration variables are set (see 'Optional Features' below):

- **'Info'** - Will show system & runtime information, and will also display if the app is running from within a Docker container and Kubernetes.
- **'Tools'** - Some tools useful in demos, such a forcing CPU load (for autoscale demos), and error/exception pages for use with App Insights or other monitoring tool.
- **'Monitor'** - Display realtime monitoring data, showing memory usage/total and process CPU load.
- **'Weather'** - (Optional) Gets the location of the client page (with HTML5 Geolocation). The resulting location is used to fetch weather data from the [OpenWeather](https://openweathermap.org/) API
- **'Todo'** - (Optional) This is a small todo/task-list app which uses MongoDB as a database.
- **'User Account'** - (Optional) When configured with Azure AD (application client id) user login button will be enabled, and an user-account details page enabled, which calls the Microsoft Graph API

![](https://img.shields.io/github/last-commit/benc-uk/nodejs-demoapp) ![](https://img.shields.io/github/release-date/benc-uk/nodejs-demoapp) ![](https://img.shields.io/github/v/release/benc-uk/nodejs-demoapp) ![](https://img.shields.io/github/commit-activity/y/benc-uk/nodejs-demoapp)

