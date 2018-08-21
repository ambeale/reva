// Display d3 graph of average food, service, and price ratings for a restaurant

const restaurant = document.querySelector('#rating-chart').getAttribute('restaurant');
d3.json(`/ratings/${restaurant}.json`, makeRatingGraph);


function makeRatingGraph(data) {
    let graph_data;

    if (data !== "no reviews") {
        graph_data = [data[0], data[1], data[2]];
        let colorRange = ['red', 'blue', 'green'];
        const color = d3.scaleOrdinal(colorRange);

        d3.select("#rating-chart")
          .selectAll("div")
          .data(graph_data)
            .enter()
            .append("div")
            .style("width", function(d) { return d*50 + "px"; })
            .style("background-color", function(d) { return color(d); })
            .text(function(d) { return d; });
        }
    else {
        graph_data = ["N/A", "N/A", "N/A"]
        d3.select("#rating-chart")
          .selectAll("div")
          .data(graph_data)
            .enter()
            .append("div")
            .style("width", function() { return 0 + "px"; })
            .style("color", "black")
            .text(function(d) { return d; });
    }
}