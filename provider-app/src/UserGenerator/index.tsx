import React from 'react'
import { useUserGenerator } from './logic'
import UserView from './UserView'

export const UserGenerator: React.FC = () => {
  const { generate, userinfo, total } = useUserGenerator()

  return (
    <>
      <button style={{ fontSize: 24, marginBottom: 40 }} onClick={generate}>
        Generate
      </button>
      {
        userinfo && <UserView
          id={userinfo.id}
          username={userinfo.username}
          password={userinfo.password}
          profile_image={userinfo.profile_image}
          joined_date={userinfo.joined_date as Date}
          total={total}
        /> 
      }
    </>
  )
}
