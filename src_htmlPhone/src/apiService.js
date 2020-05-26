import axios from 'axios'

const _debug = true;

class ApiService {

  constructor() {
    this._instance = axios.create({
      baseURL: 'http://localhost:3000/',
      // baseURL: 'https://venato-api.herokuapp.com/',
      timeout: 1000,
      headers: {'token': 'venato12345'}
    });
  }

  async get(url){
    const response = await this._instance.get(url);
    this.log(response.data);
    return response.data;
  }

  log(data){
    if(_debug){
      console.log(data);
    }
  }

}

const instance = new ApiService()

export default instance
