import { Zettle } from '@globy&#x2F;zettle';

window.testEcho = () => {
    const inputValue = document.getElementById("echoInput").value;
    Zettle.echo({ value: inputValue })
}
