(function (jsPDFAPI) {
var font = '5Lit5paHCg==';
var callAddFont = function () {
this.addFileToVFS('中文-normal.ttf', font);
this.addFont('中文-normal.ttf', '中文', 'normal');
};
jsPDFAPI.events.push(['addFonts', callAddFont])
 })(jsPDF.API);