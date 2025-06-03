import { Component } from '@angular/core';

@Component({
  selector: 'app-hollowsgoinfo',
  imports: [],
  templateUrl: './hollowsgoinfo.html',
  styleUrl: './hollowsgoinfo.css'
})
export class Hollowsgoinfo {
  ngOnInit(): void {
    this.updateBackground();
    window.addEventListener('resize', this.updateBackground);
  }
  updateBackground = () => {
    const isLandscape = window.matchMedia('(orientation: landscape)').matches;
    const imageUrl = isLandscape
      ? 'https://res.cloudinary.com/dkcgsfcky/image/upload/f_auto,q_auto/v1/WEB/kdopgq4rlbanmrurspow'
      : 'https://res.cloudinary.com/dkcgsfcky/image/upload/f_auto,q_auto/v1/WEB/e3wettuzovqwdicdhpmg';


    document.body.style.setProperty('background-image', `url('${imageUrl}')`, 'important');
    document.body.style.setProperty('background-size', 'cover', 'important');
    document.body.style.setProperty('background-repeat', 'no-repeat', 'important');
    document.body.style.setProperty('background-position', 'center', 'important');
    document.body.style.setProperty('background-color', '#1b0c04', 'important');
  };
}
