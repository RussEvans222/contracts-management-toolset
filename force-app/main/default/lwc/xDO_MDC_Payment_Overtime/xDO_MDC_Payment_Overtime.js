import {
    LightningElement,
    api
} from 'lwc';
import {
    loadScript,
    loadStyle
} from 'lightning/platformResourceLoader';
import xDO_MDC_Resources from '@salesforce/resourceUrl/xDO_MDC_Resources'

export default class Cx_payment_overtime extends LightningElement {
    @api paymentOvertime;
    @api bolChartHover;
    @api setlegend;
    @api headerTitle;
    @api strDatasetLabel2 = 'Payment';
    @api strDatasetBorderColor2;
    @api strDatasetBackgroundColor2;
    @api strxAxesLabel;
    @api stryAxesLabel;
    @api xlabel;
    @api yvalue;
    @api yCurrency = 'USD';

    chartJSRendered = false;

    renderedCallback() {
        if (this.chartJSRendered) {
            return;
        }
        this.chartJSRendered = true;

        Promise.all([
                loadScript(this, xDO_MDC_Resources + '/Scripts/ChartJSJS.js'),
                loadStyle(this, xDO_MDC_Resources + '/Scripts/ChartJSCSS.css'),
            ])
            .then(() => {
                // eslint-disable-next-line no-console
                console.info("ChartJS Loaded");
                this.initializeD3();

            })
            .catch(error => {
                this.dispatchEvent(
                    // eslint-disable-next-line no-undef
                    new ShowToastEvent({
                        title: 'Error loading ChartJS',
                        message: error.message,
                        variant: 'error',
                    }),
                );
            });
    }



    initializeD3() {
        let myXlabels = this.xlabel.split(',');
        let myYValues = this.yvalue.split(',');

        var config = {
            type: 'line',
            data: {
                // labels: [this.x1label, this.x2label, this.x3label, this.x4label, this.x5label, this.x6label, this.x7label],
                labels: myXlabels,
                datasets: [{
                    label: this.strDatasetLabel2,
                    fill: false,
                    backgroundColor: this.strDatasetBackgroundColor2,
                    borderColor: this.strDatasetBorderColor2,
                    data: myYValues,
                    borderWidth: 4
                }]
            },
            options: {
                responsive: true,
                legend: {
                    display: this.setlegend,
                    position: 'bottom',
                },
                title: {
                    display: false,
                    text: 'Chart.js Line Chart'
                },
                tooltips: {
                    mode: 'index',
                    intersect: false,
                },
                hover: {
                    mode: 'nearest',
                    intersect: this.bolChartHover
                },
                scales: {
                    xAxes: [{

                        scaleLabel: {
                            display: true,
                            labelString: this.strxAxesLabel
                        }
                    }],
                    yAxes: [{
                        ticks: {
                            callback:  (value, index, values)=> {
                                //return value.toLocaleString("en-US", { style: "currency", currency: "USD", minimumFractionDigits: 0, maximumFractionDigits: 0 });
                               
                                let formatter = Intl.NumberFormat("en", {
                                    notation: "compact",
                                    style: "currency",
                                    currency:  this.yCurrency
                                });
                                return formatter.format(value);
                            }
                        },

                        scaleLabel: {
                            display: true,
                            labelString: this.stryAxesLabel
                        }
                    }]
                },
                annotation: {
                    annotations: [{
                        type: 'line',
                        mode: 'horizontal',
                        scaleID: 'y-axis-0',
                        value: 5,
                        borderColor: 'rgb(75, 192, 192)',
                        borderWidth: 4,
                        label: {
                            enabled: false,
                            content: 'Test label'
                        }
                    }]
                }
            }
        };
        var ctx = this.template.querySelector('canvas').getContext('2d');
        // eslint-disable-next-line no-undef
        window.myLine = new Chart(ctx, config);

        function checkColor(code) {
            if (code.startsWith("#")) {
                code = hexToRgb(code).rgb;
            }
            return code;
        }

        function hexToRgb(hex) {
            var result = /^#?([a-f\d]{2})([a-f\d]{2})([a-f\d]{2})$/i.exec(hex);
            return result ? {
                r: parseInt(result[1], 16),
                g: parseInt(result[2], 16),
                b: parseInt(result[3], 16),
                rgb: "" + (parseInt(result[1], 16)) + "," + parseInt(result[2], 16) + "," + parseInt(result[3], 16)
            } : null;
        }
    }
}