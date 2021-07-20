<!-- TABLE OF CONTENTS -->
<details open="open">
  <summary><h2 style="display: inline-block">Table of Contents</h2></summary>
  <ol>
    <li>
      <a href="#about-the-project">About The Project</a>
    </li>
    <li>
      <a href="#getting-started">Getting Started</a>
      <ul>
        <li><a href="#prerequisites">Prerequisites</a></li>
      </ul>
    </li>
    <li><a href="#usage">Usage</a></li>
    <li><a href="#contributing">Contributing</a></li>
    <li><a href="#license">License</a></li>
    <li><a href="#contact">Contact</a></li>
  </ol>
</details>



<!-- ABOUT THE PROJECT -->
## About The Project

This is a script to backup ZFS volumes to local and to a remote host.
It was tought for Proxmox VE but it works with any system setup with ZFS.

The script automatically delete the oldest backup if number o backups is higher than $REDUNDANCY
It only works in local, as the remote is supposed to have a different number of backups stored.


<!-- GETTING STARTED -->
## Getting Started

To get a local copy up and running follow these simple steps.

### Prerequisites

This is the only prerequisite of this script:
* pigz

You should also have the ssh key exchanged between host and remote host


<!-- USAGE EXAMPLES -->
## Usage

The usage is simple just open the script and change the variables at the beginning to what suits you and run it.
One parameter is required and it specify what kind of backup you're doing:
- daily
- weekly
- monthly

The only thing it does is change the directory name


<!-- CONTRIBUTING -->
## Contributing

Contributions are what make the open source community what it is. Any contributions you make are **greatly appreciated**.

1. Fork the Project
2. Create your Feature Branch (`git checkout -b feature/AmazingFeature`)
3. Commit your Changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the Branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request



<!-- LICENSE -->
## License

Distributed under the GPLv3 License. See `LICENSE` for more information.



<!-- CONTACT -->
## Contact

Tommaso Perondi - tommaso@eniacom.com


