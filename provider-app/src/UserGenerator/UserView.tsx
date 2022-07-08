import './UserView.css'

type UserViewProps = {
    id: string
    username: string
    password: string
    profile_image: string
    joined_date: Date
};

type DataRowProps = {
  header:string,
  content:string
}

const DataRow = ({header,content}:DataRowProps): JSX.Element  => {
  return(
    <h3>
      <span className='data-header'>{header} :</span>
      <span className='data-content'>{content}</span>
    </h3>
  )
}

const UserView = (props: UserViewProps): JSX.Element => {
    return(
      <div className='container'>
        <img src={props.profile_image} alt='profile-image'/>
        <div className="content-container">
          <DataRow header='ID' content={props.id}/>
          <DataRow header='Username' content={props.username}/>
          <DataRow header='Password' content={props.password}/>
          <DataRow header='Joined Date' content={props.joined_date.toISOString()}/>
        </div>
      </div>
    );
};

export default UserView;