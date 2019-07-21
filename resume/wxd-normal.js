(function (jsPDFAPI) {
var font = '5Lit5paHCg==';
var callAddFont = function () {
this.addFileToVFS('wxd-normal.ttf', font);
this.addFont('wxd-normal.ttf', 'wxd', 'normal');
};
jsPDFAPI.events.push(['addFonts', callAddFont])
 })(jsPDF.API);