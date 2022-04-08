package pl.poznan.put.maxitserver;

import org.apache.commons.exec.CommandLine;
import org.apache.commons.exec.DefaultExecutor;
import org.apache.commons.exec.PumpStreamHandler;
import org.apache.commons.io.IOUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.http.HttpStatus;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.server.ResponseStatusException;

import java.io.ByteArrayOutputStream;
import java.io.IOException;
import java.nio.charset.StandardCharsets;

@RestController
@RequestMapping("/")
public class Controller {
  static final Logger LOGGER = LoggerFactory.getLogger(Controller.class);

  @PostMapping(value = "/", consumes = "text/plain", produces = "text/plain")
  public String convert(@RequestBody String input) {
    final var outputStream = new ByteArrayOutputStream();
    final var errorStream = new ByteArrayOutputStream();
    final var inputStream = IOUtils.toInputStream(input, StandardCharsets.UTF_8);

    try {
      final var executor = new DefaultExecutor();
      executor.setStreamHandler(new PumpStreamHandler(outputStream, errorStream, inputStream));
      executor.execute(new CommandLine("/entrypoint.sh"));
      return outputStream.toString(StandardCharsets.UTF_8);
    } catch (IOException e) {
      final var message =
          String.format(
              "Failed to run MAXIT%nStandard output:%n%s%nStandard error:%n%s",
              outputStream.toString(StandardCharsets.UTF_8),
              errorStream.toString(StandardCharsets.UTF_8));
      Controller.LOGGER.error(message, e);
      throw new ResponseStatusException(HttpStatus.INTERNAL_SERVER_ERROR, message, e);
    }
  }
}
