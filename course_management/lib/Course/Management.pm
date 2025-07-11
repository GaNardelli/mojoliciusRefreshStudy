package Course::Management;
use Mojo::Base 'Mojolicious', -signatures;
use YAML qw(LoadFile);
use Mojo::Home;

# This method will run once at server start
sub startup ($self) {

  # Load configuration from config file
  my $config = $self->plugin('NotYAMLConfig');

  my $home = Mojo::Home->new();
  $home->detect;
  my $course_config = LoadFile($home->child($config->{course_config}));

  # Configure the application
  $self->secrets($config->{secrets});

  # Router
  my $r = $self->routes;

  # Normal route to controller
  $r->get('/' => {cc => $course_config})->to('Example#welcome');
  $r->get('/course/:id' => {cc => $course_config})->to('Course#list_exercises');
  $r->post('/upload' => {cc => $course_config})->to('Course#upload');
}

1;
