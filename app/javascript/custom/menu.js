// トグルリスナーを追加してクリックをリッスンする
// addEventListenerを使用して、クリックイベントをリッスンする
//  trubo:loadイベントを使用して、ページが読み込まれたときにリスナーを追加する
document.addEventListener("turbo:load", function() {
  // #hamburgerはハンバーガーメニューのID
  // そのIDを持つ要素が存在する場合にクリックイベントリスナーを追加する
  let hamburger = document.querySelector("#hamburger");
  if (hamburger){
    // ハンバーガーメニューがクリックされたときに、#navbar-menuのcollapseクラスをトグルする
    hamburger.addEventListener("click", function(event) {
      event.preventDefault();
      let menu = document.querySelector("#navbar-menu");
      menu.classList.toggle("collapse");
    });
  }

  let account = document.querySelector("#account");
  if (account) {
    account.addEventListener("click", function(event) {
      event.preventDefault();
      let menu = document.querySelector("#dropdown-menu");
      menu.classList.toggle("active");
    });
  }
});