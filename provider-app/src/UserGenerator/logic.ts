import cuid from 'cuid'
import { useState } from 'react'
import { randomDate } from '../utils/randomDate'
import { faker } from '@faker-js/faker'
import axios from 'axios'
import moment from 'moment';

interface UserProps {
  id: string
  username: string
  password: string
  profile_image: string
  joined_date: Date | string
}

export const useUserGenerator = () => {
  const [userinfo, setUserinfo] = useState<UserProps | null>(null)

  const unixtimeToPostgrestimestamp = (date:Date) => moment(date).format("YYYY-MM-DD HH:mm:ss"); 

  const generate = () => {
    const user: UserProps = {
      id: `user${cuid()}`,
      username: faker.internet.userName(),
      password: faker.random.alphaNumeric(10),
      profile_image: `https://api.lorem.space/image/face?w=150&h=150&hash=${faker.random.alphaNumeric(
        8
      )}`,
      joined_date: unixtimeToPostgrestimestamp(randomDate(new Date(2019, 0, 1), new Date())),
    }

    axios({
      method: 'post',
      url: 'http://localhost:8080/user',
      data: user
    })
    .then((response)=>{
      console.log(response);
    })
    .catch((error)=>{
      console.log(error);
    })

    setUserinfo(user)
  }

  return {
    generate,
    userinfo,
  }
}
