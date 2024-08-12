import { Zettle } from '@globy-app/zettle';

window.testPayment = async () => {
  const inputValue = parseFloat(document.getElementById('paymentInput').value);
  console.log(inputValue);
  const response = await Zettle.chargeAmount({ amount: inputValue });
  console.log(response);

  document.getElementById('paymentOutput').innerText = JSON.stringify(response);
};

window.testInitialize = devMode => {
  Zettle.initialize({ developermode: devMode });
};

window.testSettings = () => {
  Zettle.openSettings();
};

window.testLogout = () => {
  Zettle.logout();
};
