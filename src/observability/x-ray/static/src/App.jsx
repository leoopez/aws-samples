import { useState } from "react";

function App() {
  const [formData, setFormData] = useState({
    name: "",
    breed: "",
    age: "",
    imageUrl: "",
  });

  const onClickFetchData = async () => {
    console.log("onClickFetchData");
    const response = await fetch("https://dog.ceo/api/breeds/image/random");
    const data = await response.json();
    setFormData({
      ...formData,
      imageUrl: data.message,
    });
  };

  const onInputChange = (event, key) => {
    setFormData({
      ...formData,
      [key]: event.target.value,
    });
  };

  const onSubmit = async (event) => {
    event.preventDefault();
    const response = await fetch(`${window.location.host}/test/validate-dog`, {
      method: "POST",
      body: JSON.stringify(formData),
      headers: {
        "Content-Type": "application/json",
      },
    });
    const data = await response.json();
    console.log(data);
  };

  const onClickGetDogs = async () => {
    const response = await fetch(`${window.location.host}/test/get-dogs`);
    const data = await response.json();
    console.log(data);
  };

  return (
    <>
      <h1>Welcome to DogsBook</h1>
      <p>A AWS Sample to view X Ray implementation.</p>
      <form id="form" onSubmit={onSubmit}>
        <div className="form">
          <h3>Add Dog</h3>
          <input
            type="text"
            placeholder="Dog Name"
            value={formData.name}
            onChange={(e) => onInputChange(e, "name")}
          />
          <input
            type="text"
            placeholder="Dog Breed"
            value={formData.name}
            onChange={(e) => onInputChange(e, "breed")}
          />
          <input
            type="text"
            placeholder="Dog Age"
            value={formData.name}
            onChange={(e) => onInputChange(e, "age")}
          />
          <input
            disabled
            type="text"
            name="dogImage"
            placeholder="Dog Image"
            id="inputDogURLValue"
          />
          <button type="button" id="addImage" onClick={onClickFetchData}>
            Change Image
          </button>
          <img
            id="dogImage"
            className="image"
            src={formData.imageUrl}
            alt="Click to button to change Image"
          />
          <button type="submit">Submit</button>
        </div>
      </form>
      <div>
        <button onClick={onClickGetDogs}>View Dogs</button>
      </div>
    </>
  );
}

export default App;
