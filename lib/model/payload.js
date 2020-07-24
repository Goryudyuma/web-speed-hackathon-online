export class Payload {
  constructor(source) {
    this.data = JSON.stringify(source.data)
      .split('https://ryotasugawara.github.io/')
      .join('/');
  }

  toResponse() {
    try {
      const data = JSON.parse(this.data);
      return {
        data,
      };
    } catch (e) {
      console.error('Failed to parse Payload to Response', e);
      throw new Error(e);
    }
  }
}
