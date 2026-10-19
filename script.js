const year = document.querySelector("#year");
const regionDialog = document.querySelector("#region-dialog");

if (year) year.textContent = new Date().getFullYear();

// 지역 선택 창은 방문(브라우저 세션)당 한 번만 띄웁니다.
// 전화 상담 링크(#contact)로 들어온 경우에도 띄우지 않습니다.
const regionDialogKey = "regionDialogShown";
let regionDialogShown = false;
try {
  regionDialogShown = sessionStorage.getItem(regionDialogKey) === "1";
  sessionStorage.setItem(regionDialogKey, "1");
} catch (error) {
  regionDialogShown = document.referrer.startsWith(window.location.origin);
}
const skipRegionDialog = regionDialogShown || window.location.hash !== "";

if (regionDialog instanceof HTMLDialogElement && !skipRegionDialog) {
  regionDialog.showModal();
  document.body.classList.add("region-dialog-open");
  regionDialog.addEventListener("close", () => {
    document.body.classList.remove("region-dialog-open");
  });
  regionDialog.addEventListener("click", (event) => {
    if (event.target === regionDialog) regionDialog.close();
  });
}
