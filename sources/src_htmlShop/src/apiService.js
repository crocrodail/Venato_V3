import axios from 'axios'

const _debug = false;

class ApiService {

  constructor() {
    this._instance = axios.create({
      // baseURL: 'http://localhost:3000/',
      baseURL: 'https://venato-api.herokuapp.com/',
      timeout: 1000,
      headers: {'token': 'venato12345'}
    });
  }

  async get(url){
    const response = await this._instance.get(url);
    this.log(response.data);
    return response.data;
  }

  async delete(url){
    const response = await this._instance.delete(url);
    this.log(response.data);
    return response.data;
  }

  async post(url, data){
    const response = await this._instance.post(url, data);
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
