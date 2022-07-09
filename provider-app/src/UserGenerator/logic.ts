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
  joined_date: Date
}

export const useUserGenerator = () => {
  const [userinfo, setUserinfo] = useState<UserProps | null>(null)
  const [total, setTotal] = useState<number>(0)
  
  const unixtimeToPostgrestimestamp = (date:Date) => moment(date).format("YYYY-MM-DD HH:mm:ss"); 

  const generate = () => {
    const user: UserProps = {
      id: `user${cuid()}`,
      username: faker.internet.userName(),
      password: faker.random.alphaNumeric(10),
      profile_image: `https://api.lorem.space/image/face?w=150&h=150&hash=${faker.random.alphaNumeric(
        8
      )}`,
      joined_date: randomDate(new Date(2019, 0, 1), new Date()),
    }

    setUserinfo(user)

    // first insert user to data store
    axios({
      method: 'post',
      url: 'https://run-sql-xliijuge3q-dt.a.run.app/user',
      data: {...user,joined_date: unixtimeToPostgrestimestamp(user.joined_date as Date)}
    })
      .then(()=>{
        // then get number of total users
        axios({
          method: 'get',
          url: 'https://run-sql-xliijuge3q-dt.a.run.app/count',
          data: {...user,joined_date: unixtimeToPostgrestimestamp(user.joined_date as Date)}
        })
        .then((response) => {
          console.log(response);
          setTotal(response.data.count)
        });
      })

  }

  return {
    generate,
    userinfo,
    total
  }
}
