import { Component, OnInit, OnDestroy, QueryList, ViewChildren, ElementRef } from '@angular/core';
import { NgForOf } from '@angular/common';

@Component({
  selector: 'app-hollowsgoinfo',
  standalone: true,
  imports: [NgForOf],
  templateUrl: './hollowsgoinfo.html',
  styleUrls: ['./hollowsgoinfo.css']
})
export class Hollowsgoinfo implements OnInit, OnDestroy {
  images: string[] = [
    'https://res.cloudinary.com/dkcgsfcky/image/upload/f_auto,q_auto/v1/WEB/Fotos_HollowsGo/u3rayqj3ozb0tmkucf0p',
    'https://res.cloudinary.com/dkcgsfcky/image/upload/f_auto,q_auto/v1/WEB/Fotos_HollowsGo/azevfdojdy9gwtwsvjpg',
    'https://res.cloudinary.com/dkcgsfcky/image/upload/f_auto,q_auto/v1/WEB/Fotos_HollowsGo/i22hxtu0hrlqpvwnpvus'
  ];

  tenda: string[] = [
    'https://res.cloudinary.com/dkcgsfcky/image/upload/f_auto,q_auto/v1/WEB/Fotos_HollowsGo/gz60njhmwp3ultysdic5',
    'https://res.cloudinary.com/dkcgsfcky/image/upload/f_auto,q_auto/v1/WEB/Fotos_HollowsGo/s2cuqbfigljiu45ajpl5',
    'https://res.cloudinary.com/dkcgsfcky/image/upload/f_auto,q_auto/v1/WEB/Fotos_HollowsGo/vtpb8pbzq9twlhu7t0t9'
  ];

  index: number = 0;

  // Referències a tots els vídeos amb #videoPlayer
  @ViewChildren('videoPlayer') videoPlayers!: QueryList<ElementRef<HTMLVideoElement>>;

  // Estat per cada vídeo: si està reproduint, mut, progress
  videoStates: { isPlaying: boolean; isMuted: boolean; progress: number }[] = [];

  ngOnInit(): void {
    this.updateBackground();
    window.addEventListener('resize', this.updateBackground.bind(this));
    // Inicialitzem 2 vídeos (canvia segons el nombre que tinguis)
    this.videoStates = [
      { isPlaying: false, isMuted: true, progress: 0 },
      { isPlaying: false, isMuted: true, progress: 0 }
    ];
  }

  ngOnDestroy(): void {
    document.body.style.backgroundImage = '';
    document.body.style.backgroundColor = '';
    window.removeEventListener('resize', this.updateBackground);
  }

  prevSlide(): void {
    this.index = (this.index - 1 + this.images.length) % this.images.length;
  }

  nextSlide(): void {
    this.index = (this.index + 1) % this.images.length;
  }

  getTransform(): string {
    return `translateX(-${this.index * 100}%)`;
  }

  togglePlay(index: number): void {
    const video = this.videoPlayers.toArray()[index].nativeElement;
    if (video.paused) {
      video.play();
      this.videoStates[index].isPlaying = true;
    } else {
      video.pause();
      this.videoStates[index].isPlaying = false;
    }
  }

  toggleMute(index: number): void {
    const video = this.videoPlayers.toArray()[index].nativeElement;
    video.muted = !video.muted;
    this.videoStates[index].isMuted = video.muted;
  }

  updateProgress(index: number): void {
    const video = this.videoPlayers.toArray()[index].nativeElement;
    if (video.duration) {
      this.videoStates[index].progress = (video.currentTime / video.duration) * 100;
    } else {
      this.videoStates[index].progress = 0;
    }
  }

  seekVideo(event: MouseEvent, index: number): void {
    const video = this.videoPlayers.toArray()[index].nativeElement;
    const target = event.currentTarget;
    if (!(target instanceof HTMLElement)) {
      return;
    }
    const rect = target.getBoundingClientRect();
    const clickX = event.clientX - rect.left;
    const width = rect.width;
    const clickRatio = clickX / width;

    if (video.duration) {
      video.currentTime = video.duration * clickRatio;
    }
  }

  private updateBackground(): void {
    const isLandscape = window.matchMedia('(orientation: landscape)').matches;
    const imageUrl = isLandscape
      ? 'https://res.cloudinary.com/dkcgsfcky/image/upload/f_auto,q_auto/v1/WEB/kdopgq4rlbanmrurspow'
      : 'https://res.cloudinary.com/dkcgsfcky/image/upload/f_auto,q_auto/v1/WEB/e3wettuzovqwdicdhpmg';

    document.body.style.backgroundImage = `url('${imageUrl}')`;
    document.body.style.backgroundSize = 'cover';
    document.body.style.backgroundRepeat = 'no-repeat';
    document.body.style.backgroundPosition = 'center';
    document.body.style.backgroundColor = '#1b0c04';
  }

  protected readonly HTMLElement = HTMLElement;
}
