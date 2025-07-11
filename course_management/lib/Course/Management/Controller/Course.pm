package Course::Management::Controller::Course;
use Mojo::Base 'Mojolicious::Controller', -signatures;
use Mojo::Home;
# use Mojo::Upload;

sub list_exercises ($self) {
  my $id = $self->param('id');
  my $course_config = $self->stash('cc');
  my ($course) = grep {$_->{id} eq $id} @$course_config; 
  $self->render(course => $course);
}

sub upload ($self) {
  my $id = $self->param('id');

  # verifica se o ID existe
  my $course_config = $self->stash('cc');
  my ($course) = grep {$_->{id} eq $id} @$course_config; 
  die "'$id'" if not $course;

  my $home = Mojo::Home->new();
  $home->detect;

  my $upload = $self->req->upload('upload');
  # my $upload = Mojo::Upload->new;
  my $dir = $home->child('data', $course->{id});
  $dir->make_path;
  my $filename = $dir->child('a.txt');
  $upload->move_to($filename);
  
  $self->render(template => 'course/list_exercises', course => $course, msg_upload => "File uploaded")
}

1;