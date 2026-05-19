document.addEventListener("DOMContentLoaded", function () {
    const today = new Date().toISOString().split('T')[0];
    document.querySelector('input[type="date"]').value = today;
});







document.addEventListener("DOMContentLoaded", function () {

    const canvas = document.getElementById("signatureCanvas");
    const signaturePad = new SignaturePad(canvas);

    // Make canvas responsive
    function resizeCanvas() {
    const ratio = Math.max(window.devicePixelRatio || 1, 1);

    const width = canvas.offsetWidth;
    const height = 150;

    canvas.width = width * ratio;
    canvas.height = height * ratio;

    canvas.style.width = width + "px";
    canvas.style.height = height + "px";

    canvas.getContext("2d").scale(ratio, ratio);
}

    window.addEventListener("resize", resizeCanvas);
    resizeCanvas();

    // Clear button
    document.getElementById("clearSignature").addEventListener("click", function () {
        signaturePad.clear();
    });

    // Save signature before form submit
    document.querySelector("form").addEventListener("submit", function (e) {

        if (signaturePad.isEmpty()) {
            alert("Please provide a signature.");
            e.preventDefault();
            return;
        }

        const signatureData = signaturePad.toDataURL();
        document.getElementById("signatureData").value = signatureData;
    });

});
