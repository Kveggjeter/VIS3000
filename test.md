test
```js client
import { LitElement, html } from 'https://unpkg.com/lit-element?module';

class MyEl extends LitElement {
  render() {
    this.innerHTML = 'I am alive';
  }
}
console.log('heihei')

customElements.define('my-el', MyEl);
```
