const form = document.querySelector("#consultation-form");
const formStatus = document.querySelector("#form-status");
const year = document.querySelector("#year");

if (year) year.textContent = new Date().getFullYear();

if (form && formStatus) {
  form.addEventListener("submit", (event) => {
    event.preventDefault();
    formStatus.textContent = "상담 접수 기능은 연락처 연결 후 활성화됩니다.";
  });
}