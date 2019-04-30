# Explore

## Tech used
I utilized Elixir for this project as I love its pattern matching abilities and functional programming seemed like the ideal paradigm for a crawler based progam. 

## Installation
### Docker
if you have docker on your device, simply run the following commands:
```
docker build . -t explore
docker run -it --name=explorer explore
``` 
Once you are in iex in the container, run:
```
Explore.explore("")
```
to start the crawler at the root directory of your site.

After it prints `:ok`, a `stats.txt` will be written where you can examine the links. In order to view the folder, you have to exit the container with `ctrl-c ctrl-c` and then execute
```
docker start explorer
docker exec -it explorer bash
cat stats.txt
```
and you will be able to view all of those cool stats

## Issues Encounterd
Due to time constraints, I was not able to print out my tf matrix to a csv file. It turns out that Elixir is not too friendly when it comes to printing out to files. Other than that, I struggled with implementing an effective url constructor for relative paths. Despite getting pretty good results with my implementation, there were some outliers as you'll see in the statistics. 

## Future Developments
This is a work in progress, but I will be iterating on it and cleaning it throughout the semester. I hope to make it more functional by getting rid of my store module and instead opting for a Genserver where I can send messages. I want to reduce side-effects as much as possible. 

Thank you and I am eager to hear your feedback!
