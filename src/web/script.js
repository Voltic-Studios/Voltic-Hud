$(document).ready(function () {

  const fadeInOptions = { duration: "slow" };
  const fadeOutOptions = { duration: "slow" };
  const boxShadowStyle = "0px 0px 7px 3px rgba(41, 41, 41, 0.8)";
  const backgroundStyle = (percentage) => `linear-gradient(rgba(41, 41, 41, 0.8) 0 0) 0 0/${percentage}% no-repeat #C3C3C3`;

  setTimeout(function () {
    $("body").fadeIn(fadeInOptions);
    updatePlayerHUD({
      health: 100,
      armor: 100,
      thirst: 50,
      hunger: 100,
      stamina: 100,
      fuel: 100
    });
  }, 2000);

  function updatePlayerHUD(data) {
    const elements = [
      { id: "health", value: data.health },
      { id: "armor", value: data.armor },
      { id: "thirst", value: data.thirst },
      { id: "hunger", value: data.hunger },
      { id: "stamina", value: data.stamina }
    ];

    elements.forEach(el => {
      const container = $(`#${el.id}-container`);
      const element = $(`#${el.id}`);

      if (el.value > 0) {
        container.fadeIn(fadeInOptions);
        element.css("background", backgroundStyle(el.value)).css("box-shadow", boxShadowStyle);
      } else if (el.id === "armor") {
        container.fadeOut(fadeOutOptions);
      }
    });

    $("#fuel").html(data.fuel);
  }

  window.addEventListener("message", function (event) {
    const data = event.data;

    if (data.action === "carhud") {
      handleCarHUD(data);
    } else if (data.action === "showPlayerHUD") {
      $("body").fadeIn(fadeInOptions);
    } else if (data.action === "hidePlayerHUD") {
      $("body").fadeOut(fadeOutOptions);
    } else if (data.action === "updatePlayerHUD") {
      updatePlayerHUD(data);
    }
  });

  function handleCarHUD(data) {
    const velocity = data.vel || 0;
    showCarHUD(data.toggle && velocity > 0);

    $(".vel").html(velocity);

    $(".kmh").html(data.type);
    $("#fuel").html(data.fuel);
  }

  function showCarHUD(show) {
    if (show) {
      $(".carhud-container, .fuel").slideDown(300);
    } else {
      $(".carhud-container, .fuel").slideUp(300);
    }
  }

});
