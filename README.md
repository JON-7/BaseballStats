# MLB Season Stats

## About
- Application that displays stats of the current MLB season
- All stats are all up-to-date

## Features: 
- Current division standings
- League leaders from both the American League and National League
- Individual players stats 
- 40 man rosters
- Add players to a favorites list

## App Previews: 
Division Standings             |  League Leaders
:-------------------------:|:-------------------------:
![](https://media.giphy.com/media/wwSCfMjVENkm7UKitR/giphy.gif)  |  ![](https://media.giphy.com/media/oEvOinmeGy0Tv5f8JK/giphy.gif)


Team Roster             |  Add Favorite Players
:-------------------------:|:-------------------------:
![](https://media.giphy.com/media/EDAvYMmvpJpXAdLIjs/giphy.gif)  |  ![](https://media.giphy.com/media/l98d1Wwvp9IhRu4RyZ/giphy.gif)

## About the project
- Collection views were done using compositional layout
    - Each section contained a vertical and horizontal group in order to display the information in an efficient way 
- Data persisted using user defaults
- Used the Result type to make networking calls
- UI done all programmatically 

## APIs Used:
####Baseball team API
- https://rapidapi.com/api-sports/api/api-baseball/endpoints
- Freemium API
- Update the request header in the getStandings function inside the TeamNetworkManger file

####MLB data API
- https://rapidapi.com/theapiguy/api/mlb-data
- No key needed
