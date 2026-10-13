const form = document.querySelector("#consultation-form");
const formStatus = document.querySelector("#form-status");
const year = document.querySelector("#year");
const regionDialog = document.querySelector("#region-dialog");

if (year) year.textContent = new Date().getFullYear();

if (regionDialog instanceof HTMLDialogElement) {
  regionDialog.showModal();
  document.body.classList.add("region-dialog-open");
  regionDialog.addEventListener("close", () => {
    document.body.classList.remove("region-dialog-open");
  });
  regionDialog.addEventListener("click", (event) => {
    if (event.target === regionDialog) regionDialog.close();
  });
}

if (form && formStatus) {
  const query = new URLSearchParams(window.location.search);

  if (query.get("submitted") === "true") {
    formStatus.textContent = "상담 신청이 접수되었습니다. 확인 후 연락드리겠습니다.";
  }

  form.addEventListener("submit", () => {
    const submitButton = form.querySelector('button[type="submit"]');
    if (submitButton) submitButton.disabled = true;
    formStatus.textContent = "상담 신청을 전송하고 있습니다.";
  });
}