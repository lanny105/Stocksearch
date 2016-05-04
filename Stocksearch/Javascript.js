$(document).ready(function() {

});


var hello = function(message) {
    
    var Markit = {};
    
    Markit.InteractiveChartApi = function(symbol,duration){
        this.symbol = symbol.toUpperCase();
        this.duration = duration;
        this.PlotChart();
    };
    
    Markit.InteractiveChartApi.prototype.PlotChart = function(){
        
        var params = JSON.stringify( this.getInputParams());
        
        console.log(params);
        
        $.ajax({
               
               data: {para:params},
               
               url: "https://stocksearch-1297.appspot.com/index.php",
               dataType: "json",
               context: this,
               success: function(json){
               //Catch errors
               console.log(json);
               if (!json || json.Message){
               console.error("Error: ", json.Message);
               return;
               }
               this.render(json);
               },
               error: function(response,txtStatus){
               console.log(response,txtStatus)
               }
               });
    };
    
    Markit.InteractiveChartApi.prototype.getInputParams = function(){
        return {
        Normalized: false,
        NumberOfDays: this.duration,
        DataPeriod: "Day",
        Elements: [
                   {
                   Symbol: this.symbol,
                   Type: "price",
                   Params: ["ohlc"] //ohlc, c = close only
                   }
                   ]
            
        }
    };
    
    Markit.InteractiveChartApi.prototype._fixDate = function(dateIn) {
        var dat = new Date(dateIn);
        return Date.UTC(dat.getFullYear(), dat.getMonth(), dat.getDate());
    };
    
    Markit.InteractiveChartApi.prototype._getOHLC = function(json) {
        var dates = json.Dates || [];
        var elements = json.Elements || [];
        var chartSeries = [];
        
        if (elements[0]){
            
            for (var i = 0, datLen = dates.length; i < datLen; i++) {
                var dat = this._fixDate( dates[i] );
                var pointData = [
                                 dat,
                                 elements[0].DataSeries['open'].values[i],
                                 elements[0].DataSeries['high'].values[i],
                                 elements[0].DataSeries['low'].values[i],
                                 elements[0].DataSeries['close'].values[i]
                                 ];
                chartSeries.push( pointData );
            };
        }
        return chartSeries;
    };
    
    Markit.InteractiveChartApi.prototype._getVolume = function(json) {
        var dates = json.Dates || [];
        var elements = json.Elements || [];
        var chartSeries = [];
        
        if (elements[1]){
            
            for (var i = 0, datLen = dates.length; i < datLen; i++) {
                var dat = this._fixDate( dates[i] );
                var pointData = [
                                 dat,
                                 elements[1].DataSeries['volume'].values[i]
                                 ];
                chartSeries.push( pointData );
            };
        }
        return chartSeries;
    };
    
    Markit.InteractiveChartApi.prototype.render = function(data) {
        //console.log(data)
        // split the data set into ohlc and volume
        var ohlc = this._getOHLC(data);
        
        
        // create the chart
        
//        $('#container').setOptions({
//                              lang: {
//                                     resetZoom: "",                       }
//                              });
        
        $('#container').highcharts('StockChart', {
                                   
                                   rangeSelector: {
                                   
                                   selected: 0,
                                   allButtonsEnabled: true,
                                   inputEnabled: false,
                                   buttons: [{
                                             type: 'week',
                                             count: 1,
                                             text: '1w'
                                             },
                                             {
                                             type: 'month',
                                             count: 1,
                                             text: '1m'
                                             }, {
                                             type: 'month',
                                             count: 3,
                                             text: '3m'
                                             }, {
                                             type: 'month',
                                             count: 6,
                                             text: '6m'
                                             }, {
                                             type: 'ytd',
                                             text: 'YTD'
                                             }, {
                                             type: 'year',
                                             count: 1,
                                             text: '1y'
                                             }, {
                                             type: 'all',
                                             text: 'All'
                                             }]
                                   },
                                   
                                   title: {
                                   text: this.symbol + ' Stock Value'
                                   },
                                   
                                   yAxis: [{
                                           title: {
                                           text: ''
                                           },
                                           // height: 300,
                                           // lineWidth: 2
                                           min: 0
                                           }],
                                   
                                   series : [{
                                             name : 'AAPL Stock Price',
                                             data : ohlc,
                                             type : 'area',
                                             threshold : null,
                                             tooltip : {
                                             valueDecimals : 2
                                             },
                                             fillColor : {
                                             linearGradient : {
                                             x1: 0,
                                             y1: 0,
                                             x2: 0,
                                             y2: 1
                                             },
                                             stops : [
                                                      [0, Highcharts.getOptions().colors[0]],
                                                      [1, Highcharts.Color(Highcharts.getOptions().colors[0]).setOpacity(0).get('rgba')]
                                                      ]
                                             }
                                             }],
                                   });
    };
    
    var sym = $.url().param('symbol') || message;
    var dur = $.url().param('duration') || 1095;
    new Markit.InteractiveChartApi(sym, dur);
}




