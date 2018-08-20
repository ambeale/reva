
const restaurant = document.querySelector('#rating-chart').getAttribute('restaurant');
d3.json(`/ratings/${restaurant}.json`, makeForceGraph);


function makeForceGraph(data) {
    console.log(data)
    let graph_data = [data[0], data[1], data[2]];
    let colorRange = ['red', 'blue', 'green'];
    let ratingRange = ['Food: ', 'Service: ', 'Price: '];
    const color = d3.scaleOrdinal(colorRange);
    const rating = d3.scaleOrdinal(ratingRange);

    d3.select("#rating-chart")
      .selectAll("div")
      .data(graph_data)
        .enter()
        .append("div")
        .style("width", function(d) { return d*100 + "px"; })
        .style("background-color", function(d) { return color(d); })
        .text(function(d) { return rating(d) + d; });

    }