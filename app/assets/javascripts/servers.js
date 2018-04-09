function refreshStats() {
  console.log("charts redrawn");
  Chartkick.eachChart( function(chart) {
    chart.refreshData();
    chart.redraw()
  });
};

window.setInterval(refreshStats, 30000);
